import React, { useEffect, useState } from 'react';
import EdiText from 'react-editext';

export default function Notes() {
    const [flowNotes, setFlowNotes] = useState('Flow Notes');

    return (
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
    )
}