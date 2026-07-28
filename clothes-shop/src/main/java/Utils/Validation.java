/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

/**
 *
 * @author Le Tan Kim
 */
public class Validation {

    public int getInt(String input) {
        if (input == null) return -1;
        int result = -1;
        try {
            result = Integer.parseInt(input);
        } catch (NumberFormatException er) {

        }
        return result;
    }

    public double getDouble(String input) {
        if (input == null) return -1;
        double result = -1;
        try {
            result = Double.parseDouble(input);
        } catch (NumberFormatException er) {

        }
        return result;
    }
    
    public float getFloat(String input) {
        if (input == null) return -1;
        float result = -1;
        try {
            result = Float.parseFloat(input);
        } catch (NumberFormatException er) {

        }
        return result;
    }

    public boolean isBlank(String input) {
        return input == null || input.trim().isEmpty();
    }

    /** Chuẩn hoá số tiền từ form (dấu phẩy / khoảng trắng). */

    public int clampQty(int qty, int stock) {
        if (qty < 1) {
            return 1;
        }
        if (stock >= 0 && qty > stock) {
            return stock;
        }
        return qty;
    }
}
