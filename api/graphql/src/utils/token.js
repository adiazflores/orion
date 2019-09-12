import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET;

export const verifyToken = request => {
  const SECRET_TOKEN_ADDON = process.env.SECRET_TOKEN_ADDON;

  const authorization = request.get('authorization');
  if (authorization) {
    const token = authorization.replace(`${SECRET_TOKEN_ADDON} `, '');
    const { userId } = jwt.verify(token, JWT_SECRET);
    return userId;
  }
  return null;
};

export const createToken = payload => {
  return jwt.sign(payload, JWT_SECRET, {
    expiresIn: '168h',
  });
};
