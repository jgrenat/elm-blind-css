port module Main exposing (main)

import Browser exposing (Document)
import GameState exposing (GameState, gameStateDecoder)
import Html exposing (div, img, text)
import Html.Attributes exposing (id, src, style)
import Html.Lazy
import Json.Decode as Decode exposing (Value)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { css : String
    , html : String
    , poster : Maybe String
    }


type State
    = Waiting


type Msg
    = OnCssChange String
    | OnHtmlChange String
    | OnGameStateChange Value


init : () -> ( Model, Cmd Msg )
init _ =
    ( { css = "", html = "", poster = Nothing }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCssChange newCss ->
            ( { model | css = newCss }, sendToServer <| SaveData model.html newCss )

        OnHtmlChange newHtml ->
            ( { model | html = newHtml }, sendToServer <| SaveData newHtml model.css )

        OnGameStateChange state ->
            Decode.decodeValue gameStateDecoder state
                |> Result.withDefault (GameState Nothing)
                |> (\gameState -> ( { model | poster = gameState.poster }, Cmd.none ))


view : Model -> Document Msg
view model =
    Document "Blind CSS Challenge "
        [ div [ style "display" "flex" ]
            [ div []
                [ div
                    [ id "html-container"
                    , style "height" "20vh"
                    , style "width" "60vw"
                    , style "border" "1px solid black"
                    , style "box-sizing" "border-box"
                    ]
                    []
                , Html.Lazy.lazy
                    (always <|
                        div
                            [ id "css-container"
                            , style "height" "calc(80vh - 10px)"
                            , style "width" "60vw"
                            , style "margin-top" "10px"
                            , style "border" "1px solid black"
                            , style "box-sizing" "border-box"
                            ]
                            []
                    )
                    ()
                ]
            , div [ id "right-column", style "margin-left" "20px" ]
                [ case model.poster of
                    Just poster ->
                        img
                            [ src poster
                            , style "max-width" "90%"
                            , style "max-height" "50vh"
                            , style "margin" "20px 10px 0 10px"
                            ]
                            []

                    Nothing ->
                        text ""
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ cssChanged OnCssChange, htmlChanged OnHtmlChange, gameStateChanged OnGameStateChange ]


port cssChanged : (String -> msg) -> Sub msg


port htmlChanged : (String -> msg) -> Sub msg


port gameStateChanged : (Value -> msg) -> Sub msg


port sendToServer : SaveData -> Cmd msg


type alias SaveData =
    { html : String, css : String }
