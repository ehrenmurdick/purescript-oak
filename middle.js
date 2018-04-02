module.exports = (req, res, next) => {
  console.log('astioaenst');
  res.header('Access-Control-Allow-Origin', '*');
  next();
};
