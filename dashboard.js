import {Elm} from './src/Dashboard.elm';
import * as firebase from 'firebase/app';
import 'firebase/firestore';

const firebaseApp = firebase.initializeApp({
    apiKey: "AIzaSyAg9fov8eMOyzKU_EE9Ht2Cxw8v-REP-fs",
    authDomain: "blind-css.firebaseapp.com",
    databaseURL: "https://blind-css.firebaseio.com",
    projectId: "blind-css",
    storageBucket: "blind-css.appspot.com",
    messagingSenderId: "142765605102",
    appId: "1:142765605102:web:e41f9a2927451325"
});
const collection = firebaseApp.firestore().collection('players');
const gameStateDocument = firebaseApp.firestore().collection('gameState')
    .doc('ehkxFmwdXtX6owQ9gCp4');

const elmApp = Elm.Dashboard.init({flags: null});

elmApp.ports.changeGameState.subscribe(gameState => {
    gameStateDocument.set({posterUrl: gameState.poster})
        .catch(console.error);
});

setInterval(() => {
    collection.get().then(data => {
        const players = data.docs.map(playerDocument => {
            const data = playerDocument.data();
            return ({id: playerDocument.id, css: data.css, html: data.html});
        });
        elmApp.ports.playersReceived.send(players);
    });
}, 3000);




class AppVisualizer extends HTMLElement {
    constructor() {
        super();
        this.attachShadow({ mode: 'open' });
        this._html = '';
        this._css = '';
    }

    set css(css) {
        this._css = css;
        this.changeContent();
    }

    set html(html) {
        this._html = html;
        this.changeContent();
    }

    changeContent() {
        this.shadowRoot.innerHTML = this._html;
        const style = document.createElement('style');
        style.innerHTML = this._css;
        this.shadowRoot.prepend(style);
    }

    connectedCallback() {
        this.changeContent();
    }
}
window.customElements.define('app-visualizer', AppVisualizer);