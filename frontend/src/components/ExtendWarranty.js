import React from 'react'

export function ExtendWarranty({extendWarranty}) {
  return (
    <>
    <h2>Extend Warranty</h2> 
    <form onSubmit={(event) => {
        event.preventDefault();

        const formData = new FormData(event.target);
        const input = formData.get("input");

        if(input) {
            extendWarranty(input);
        }
    }} >
        <div className="form-group">
          <label>Extension in Unix Time</label>
          <input className="form-control" type="text" name="input" required />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Extend" />
        </div>
    </form>
    </>
  )
}