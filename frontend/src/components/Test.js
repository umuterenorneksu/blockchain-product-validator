import React from 'react'

export function Test({test}) {
  return (
    <>
    <h2>Test</h2> 
    <form onSubmit={(event) => {
        event.preventDefault();

        const formData = new FormData(event.target);
        const input = formData.get("input");

        if(input) {
            test(input);
        }
    }} >
        <div className="form-group">
          <label>Recipient address</label>
          <input className="form-control" type="text" name="input" required />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Transfer" />
        </div>
    </form>
    </>
  )
}