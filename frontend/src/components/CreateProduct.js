import React from 'react'

export function CreateProduct({ createProduct }) {
  return (
    <>
    <h2>Create Product</h2>
    <button onClick={createProduct}>Create Product</button>
    </>
  )
}