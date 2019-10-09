import {Elm} from './src/Main.elm';
import * as monaco from 'monaco-editor';
import * as firebase from 'firebase/app';
import 'firebase/firestore';
import generateId from 'uuid/v4';


self.MonacoEnvironment = {
    getWorkerUrl: function (moduleId, label) {
        if (label === 'json') {
            return './json.worker.js';
        }
        if (label === 'css') {
            return './css.worker.js';
        }
        if (label === 'html') {
            return './html.worker.js';
        }
        if (label === 'typescript' || label === 'javascript') {
            return './ts.worker.js';
        }
        return './editor.worker.js';
    },
};

const firebaseApp = firebase.initializeApp({
    apiKey: "AIzaSyAg9fov8eMOyzKU_EE9Ht2Cxw8v-REP-fs",
    authDomain: "blind-css.firebaseapp.com",
    databaseURL: "https://blind-css.firebaseio.com",
    projectId: "blind-css",
    storageBucket: "blind-css.appspot.com",
    messagingSenderId: "142765605102",
    appId: "1:142765605102:web:e41f9a2927451325"
});
const documentId = generateId();
const playerDocument = firebaseApp.firestore().collection('players').doc(documentId);

const elmApp = Elm.Main.init({flags: null});

elmApp.ports.sendToServer.subscribe(data => {
    playerDocument.set({css: data.css, html:  data.html})
        .catch(console.error);
});

setTimeout(() => {
        const cssEditor = monaco.editor.create(document.getElementById('css-container'), {
            value: [
                '#main {',
                '  width: 100%;',
                '  height: 100%;',
                '  position: relative;',
                '  background-color: yellow;',
                '}',
                '',
                '#cube {',
                '  position: absolute;',
                '  width: 20%;',
                '  height: 20%;',
                '  left: 50%;',
                '  top: 50%;',
                '  transform: translateX(-50%) translateY(-50%) rotate(45deg);',
                '  background-color: red;',
                '}'

            ].join('\n'),
            language: 'css'
        });
        cssEditor.onDidChangeModelContent(modelContentChangedEvent => {
            const value = cssEditor.getValue();
            elmApp.ports.cssChanged.send(value);
        });

        const htmlEditor = monaco.editor.create(document.getElementById('html-container'), {
            value: ['<div id="main">',
                '  <div id="cube"></div>',
                '</div>'].join("\n"),
            language: 'html'
        });
        htmlEditor.onDidChangeModelContent(modelContentChangedEvent => {
            const value = htmlEditor.getValue();
            elmApp.ports.htmlChanged.send(value);
        });

    }, 1000
);
