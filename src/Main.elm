module Main exposing (main)

import Browser
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (usLocale)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


type alias Model =
    { income : String
    }


type Msg
    = Income String


calc : Float -> Float
calc income =
    if income >= 180001 then
        (income - 180000) * 0.45 + 51667

    else if income >= 120001 then
        (income - 120000) * 0.37 + 29467

    else if income >= 45001 then
        (income - 45000) * 0.325 + 5092

    else if income >= 18201 then
        (income - 18200) * 0.19

    else
        0.0


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model ""
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Income income ->
            ( { model | income = String.filter (\x -> List.member x <| String.toList ".1234567890") income }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        income =
            Maybe.withDefault 0 <| String.toFloat model.income
    in
    node "main"
        [ class "wrapper" ]
        [ node "header"
            []
            [ h1 [] [ text "Australian Income Tax Calculator 2022" ]
            ]
        , h2 [] [ text "Taxable Income" ]
        , input [ type_ "input", attribute "inputmode" "numeric", value <| "$" ++ model.income, onInput Income, autofocus True ] []
        , h2 [] [ text "Tax Payable" ]
        , div [ class "result" ] [ text <| "$" ++ (String.replace ".00" "" <| format usLocale (calc income)) ]
        , h2 [] [ text "Net after Tax" ]
        , div [ class "result" ] [ text <| "$" ++ (String.replace ".00" "" <| format usLocale (income - calc income)) ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
