import React, { useEffect, useState, Component } from 'react';

import Timer from './Timer';
import Notes from './Notes';

import { config } from './Config';
import { PublicClientApplication } from '@azure/msal-browser';

import '../css/App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Flowmodoro!</h1>
        <Timer />
        <Notes />
      </header>
    </div>
  );
}

export default App;
