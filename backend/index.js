const express = require('express')
const app = express()
const port = 80


app.get('/', (req, res) => {
  res.status(200).send('OK')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
