port module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Navigation
import Html exposing (div)
import Html.Attributes exposing (id, style)
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
    {}


type Msg
    = Noop
    | OnCssChange String
    | OnHtmlChange String


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    ( {}, Cmd.none )


view : Model -> Document Msg
view model =
    Document "Blind CSS Challenge "
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
                    , style "height" "80vh"
                    , style "width" "60vw"
                    , style "border" "1px solid black"
                    , style "box-sizing" "border-box"
                    ]
                    []
            )
            ()
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "received" msg
    in
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ cssChanged OnCssChange, htmlChanged OnHtmlChange ]


port cssChanged : (String -> msg) -> Sub msg


port htmlChanged : (String -> msg) -> Sub msg
