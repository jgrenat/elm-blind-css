port module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Navigation
import Html exposing (div, img)
import Html.Attributes exposing (id, src, style)
import Html.Lazy
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = always Noop
        , onUrlChange = always Noop
        }


type alias Model =
    { css : String
    , html : String
    , poster : Maybe String
    }


type alias GameState =
    { poster : String
    }


type Msg
    = Noop
    | OnCssChange String
    | OnHtmlChange String


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { css = "", html = "", poster = Nothing }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        OnCssChange newCss ->
            ( { model | css = newCss }, sendToServer <| SaveData model.html newCss )

        OnHtmlChange newHtml ->
            ( { model | html = newHtml }, sendToServer <| SaveData newHtml model.css )


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
            , div [ id "right-column", style "margin-left" "20px" ] [ img [ src "http://media.topito.com/wp-content/uploads/2010/09/affiche_minimaliste_024.jpg" ] [] ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ cssChanged OnCssChange, htmlChanged OnHtmlChange ]


port cssChanged : (String -> msg) -> Sub msg


port htmlChanged : (String -> msg) -> Sub msg


port sendToServer : SaveData -> Cmd msg


type alias SaveData =
    { html : String, css : String }
