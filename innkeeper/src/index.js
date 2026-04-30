require('dotenv').config();
const express = require('express');

const healthRouter = require('./routes/health');
const menuRouter = require('./routes/menu');
const ordersRouter = require('./routes/orders');

const app = express();
const PORT = process.env.PORT || 4181;

// CORS
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.sendStatus(204);
  next();
});

app.use(express.json());

app.use('/api/health', healthRouter);
app.use('/api/menu', menuRouter);
app.use('/api/orders', ordersRouter);

// Global error handler
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`Innkeeper listening on port ${PORT}`);
});
