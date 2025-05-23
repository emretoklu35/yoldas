const isAdmin = (req, res, next) => {
  // Eğer kullanıcı login olduysa ve rolü "admin" ise
  if (req.user && req.user.role === "admin") {
    return next(); // Devam et
  }

  // Aksi takdirde erişimi engelle
  return res.status(403).json({ error: "Access denied. Admins only." });
};

module.exports = isAdmin;
