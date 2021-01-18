import React, { useEffect, useState, Component } from 'react';
import EdiText from 'react-editext';

import { config } from './Config';
import Timer from './Timer';
import { PublicClientApplication } from '@azure/msal-browser';

import '../css/App.css';

function App() {
  const [flowNotes, setFlowNotes] = useState('Flow Notes');

  return (
    <div className="App">
      <header className="App-header">
        <h1>Flowmodoro!</h1>
        <Timer />
        <EdiText
          submitOnEnter
          cancelOnEscape
          editOnViewClick={true}
          viewContainerClassName='my-custom-view-wrapper'
          type="text"
          inputProps={{
            rows: 5
          }}
          saveButtonContent='Apply'
          cancelButtonContent={<strong>Cancel</strong>}
          editButtonContent='Edit Flow Notes'
          value={flowNotes}
          onSave={setFlowNotes}
        />
      </header>
    </div>
  );
}

export default App;
