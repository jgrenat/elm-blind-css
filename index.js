import {Elm} from './src/Main.elm';
import * as monaco from 'monaco-editor';


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

const elmApp = Elm.Main.init({flags: null});

setTimeout(() => {
        const cssEditor = monaco.editor.create(document.getElementById('css-container'), {
            value: [
                '#main {',
                '  width: 200px;',
                '  height: 400px;',
                '}'
            ].join('\n'),
            language: 'css'
        });
        cssEditor.onDidChangeModelContent(modelContentChangedEvent => {
            const value = cssEditor.getValue();
            elmApp.ports.cssChanged.send(value);
        });

        const htmlEditor = monaco.editor.create(document.getElementById('html-container'), {
            value: '<div id="main"></div>',
            language: 'html'
        });
        htmlEditor.onDidChangeModelContent(modelContentChangedEvent => {
            const value = htmlEditor.getValue();
            elmApp.ports.htmlChanged.send(value);
        });

    }, 1000
)