package DAO;

import DBConnection.DBConnection;
import Model.PasswordResetToken;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PasswordResetTokenDAO {
    private static final Logger LOG = Logger.getLogger(PasswordResetTokenDAO.class.getName());

    public boolean insertToken(int accountId, String tokenHash, Timestamp expiresAt) {
        String sql = "INSERT INTO PasswordResetToken (accountID, tokenHash, expiresAt, createdAt) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, accountId);
            ps.setString(2, tokenHash);
            ps.setTimestamp(3, expiresAt);
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Lỗi insertToken", ex);
        }
        return false;
    }

    public PasswordResetToken getValidToken(String tokenHash) {
        String sql = "SELECT * FROM PasswordResetToken WHERE tokenHash = ? AND usedAt IS NULL AND expiresAt > ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, tokenHash);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PasswordResetToken token = new PasswordResetToken();
                    token.setId(rs.getInt("ID"));
                    token.setAccountId(rs.getInt("accountID"));
                    token.setTokenHash(rs.getString("tokenHash"));
                    token.setExpiresAt(rs.getTimestamp("expiresAt"));
                    token.setUsedAt(rs.getTimestamp("usedAt"));
                    token.setCreatedAt(rs.getTimestamp("createdAt"));
                    return token;
                }
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Lỗi getValidToken", ex);
        }
        return null;
    }


    public boolean deleteToken(int tokenId) {
        String sql = "DELETE FROM PasswordResetToken WHERE ID = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, tokenId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Lỗi deleteToken", ex);
        }
        return false;
    }
}
