const { Router } = require('express');
const { checkConnection } = require('../db');

const router = Router();

router.get('/', async (req, res, next) => {
  try {
    const ok = await checkConnection();
    if (ok) {
      res.json({ status: 'ok', db: 'connected', timestamp: new Date().toISOString() });
    } else {
      res.status(503).json({ status: 'error', db: 'unreachable' });
    }
  } catch (err) {
    next(err);
  }
});

module.exports = router;
