module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Navigation
import Html exposing (text)
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = always Noop
        , onUrlChange = always Noop
        }


type alias Model =
    {}


type Msg
    = Noop


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    ( {}, Cmd.none )


view : Model -> Document Msg
view model =
    Document "title" [ text "Hello world!" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
