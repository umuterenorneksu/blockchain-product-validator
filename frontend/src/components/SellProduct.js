import React from 'react'

export function SellProduct({sellProduct}) {
  return (
    <>
    <h2>Sell Product</h2> 
    <form onSubmit={(event) => {
        event.preventDefault();

        const formData = new FormData(event.target);
        const input = formData.get("input");

        if(input) {
            sellProduct(input);
        }
    }} >
        <div className="form-group">
          <label>Recipient address</label>
          <input className="form-control" type="text" name="input" required />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Sell" />
        </div>
    </form>
    </>
  )
}