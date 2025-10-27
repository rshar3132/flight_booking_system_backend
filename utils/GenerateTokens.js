import jwt from 'jsonwebtoken';
import 'dotenv/config';


export default function GenerateTokens(user) {
    console.log('Generating access token for user:', user);
    const accessToken = jwt.sign(
        { sub: user.id, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: '15m' } // 15 minutes
    );
    
    console.log('Generating refresh token for user:', user);
    const refreshToken = jwt.sign(
        { sub: user.id },
        process.env.JWT_SECRET,
        { expiresIn: '7d' } // 7 days
    );

    return { accessToken, refreshToken };
}
