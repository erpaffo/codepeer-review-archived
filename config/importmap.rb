# config/importmap.rb
pin "application", preload: true
pin 'editor', to: 'editor.js'
pin 'monaco-editor', to: 'https://cdn.jsdelivr.net/npm/monaco-editor@0.45.0/+esm'
