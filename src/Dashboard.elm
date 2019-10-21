port module Dashboard exposing (main)

import Browser exposing (Document)
import GameState exposing (GameState)
import Html exposing (Html, button, div, figure, h1, img, text)
import Html.Attributes exposing (class, property, src, style)
import Html.Events exposing (onClick)
import Html.Parser
import Json.Decode as Decode exposing (Error, Value)
import Json.Encode as Encode
import Result exposing (Result(..))


main : Program () AppModel Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type AppModel
    = Home
    | Game Model


type alias Model =
    { players : List Player
    , poster : String
    }


type alias Player =
    { id : String
    , html : String
    , css : String
    }


type Msg
    = OnPlayersReceived (Result Error (List Player))
    | SelectPoster String


init : () -> ( AppModel, Cmd Msg )
init _ =
    ( Home, Cmd.none )


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg appModel =
    case ( appModel, msg ) of
        ( Home, SelectPoster poster ) ->
            ( Game { players = [], poster = poster }, changeGameState (GameState (Just poster)) )

        ( Home, _ ) ->
            ( Home, Cmd.none )

        ( Game model, OnPlayersReceived (Ok players) ) ->
            ( Game { model | players = players }, Cmd.none )

        ( Game model, OnPlayersReceived (Err _) ) ->
            ( Game model, Cmd.none )

        ( Game model, SelectPoster _ ) ->
            ( Game model, Cmd.none )


view : AppModel -> Document Msg
view appModel =
    case appModel of
        Home ->
            Document "Blind CSS Challenge " [ title, viewOptions ]

        Game model ->
            Document "Blind CSS Challenge " <|
                [ title
                , div
                    [ style "display" "flex", style "justify-content" "space-between" ]
                    (displayTemplate model.poster :: List.map showPlayer model.players)
                ]


moviePosters : List String
moviePosters =
    [ "https://www.2tout2rien.fr/wp-content/uploads/2013/05/affiches-de-films-minimalistes-superman.jpg"
    , "https://i.pinimg.com/originals/bb/1e/1b/bb1e1b351d671b37a2b8c41cea2b6f43.jpg"
    , "http://media.topito.com/wp-content/uploads/2010/09/affiche_minimaliste_121.jpg"
    , "http://media.topito.com/wp-content/uploads/2010/09/affiche_minimaliste_102.jpg"
    , "http://media.topito.com/wp-content/uploads/2010/09/affiche_minimaliste_056.jpg"
    , "http://media.topito.com/wp-content/uploads/2010/09/affiche_minimaliste_041.jpg"
    , "http://media.topito.com/wp-content/uploads/2010/09/affiche_minimaliste_024.jpg"
    , "http://media.topito.com/wp-content/uploads/2010/09/affiche_minimaliste_124.jpg"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2FMinimalism-640x635.jpg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2FPiet%20Mondrian%20%201872-1944%20-%20Tutt'Art%40.jpg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Fblind-css-10.jpg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Fblind-css-11.jpg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Fblind-test-12.jpeg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Fblind-test-13.jpg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Fblind-test-14.jpeg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Fblind-test-15.jpg?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Files-aland.png?alt=media"
    , "https://firebasestorage.googleapis.com/v0/b/blind-css.appspot.com/o/models%2Fupload_f23be9db4aaa48739046dae44c1c3bdc.jpg?alt=media"
    ]


viewOptions : Html Msg
viewOptions =
    div [ style "text-align" "center", class "posters" ]
        (List.map (\poster -> button [ class "posterButton", onClick (SelectPoster poster) ] [ img [ src poster ] [] ]) moviePosters)


title : Html msg
title =
    h1 [ style "text-align" "center" ] [ text "Blind CSS Challenge!" ]


displayTemplate : String -> Html Msg
displayTemplate source =
    figure [ style "order" "2" ]
        [ img [ src source, style "max-width" "300px" ] []
        ]


showPlayer : Player -> Html Msg
showPlayer player =
    case Html.Parser.run player.html of
        Ok _ ->
            div
                [ style "width" "30vw"
                , style "height" "30vw"
                , style "border" "1px solid black"
                , style "margin" "1vw"
                , class "player"
                ]
                [ Html.node "app-visualizer" [ property "css" (Encode.string player.css), property "html" (Encode.string player.html) ] [] ]

        Err _ ->
            div
                [ style "width" "30vw"
                , style "height" "30vw"
                , style "border" "1px solid black"
                , style "margin" "1vw"
                , style "display" "flex"
                , style "justify-content" "center"
                , style "align-items" "center"
                , class "player"
                ]
                [ text "It's HTML is invalid..." ]


subscriptions : AppModel -> Sub Msg
subscriptions appModel =
    case appModel of
        Home ->
            Sub.none

        Game _ ->
            playersReceived (Decode.decodeValue (Decode.list playerDecoder) >> OnPlayersReceived)


playerDecoder : Decode.Decoder Player
playerDecoder =
    Decode.map3 Player
        (Decode.field "id" Decode.string)
        (Decode.field "html" Decode.string)
        (Decode.field "css" Decode.string)


port changeGameState : GameState -> Cmd msg


port playersReceived : (Value -> msg) -> Sub msg
