const express = require("express");
const router = express.Router();
const pool = require("../db"); // mysql2 pool bağlantısı kullanıyorsan bu yeterli

router.get("/nearby", async (req, res) => {
  const { lat, lng, radius } = req.query;
  if (!lat || !lng || !radius) {
    return res.status(400).json({ error: "Missing query parameters" });
  }

  const sql = `
    SELECT *,
    ST_Distance_Sphere(location, POINT(?, ?)) AS distance
    FROM gas_stations
    WHERE ST_Distance_Sphere(location, POINT(?, ?)) <= ?
  `;

  try {
    const [rows] = await pool.execute(sql, [lng, lat, lng, lat, radius * 1000]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
