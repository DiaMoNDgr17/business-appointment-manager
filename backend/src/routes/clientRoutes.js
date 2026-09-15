const express = require('express');

const router = express.Router();

const authMiddleware = require('../middlewares/authMiddleware');
const clientController = require('../controllers/clientController');

router.get(
  '/',
  authMiddleware,
  clientController.getClients
);

router.post(
  '/',
  authMiddleware,
  clientController.createClient
);

router.patch(
  '/:id',
  authMiddleware,
  clientController.updateClient
);

module.exports = router;