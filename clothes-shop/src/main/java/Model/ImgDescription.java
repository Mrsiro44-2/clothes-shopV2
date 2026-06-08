/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author HP
 */
public class ImgDescription {
    private int ID;
    private String imgUrl;
    private int productID;
    private int sortOrder;

    public ImgDescription() {
    }

    public ImgDescription(int ID, String imgUrl, int productID) {
        this(ID, imgUrl, productID, 0);
    }
    
    public ImgDescription(int ID, String imgUrl, int productID, int sortOrder) {
        this.ID = ID;
        this.imgUrl = imgUrl;
        this.productID = productID;
        this.sortOrder = sortOrder;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }
}
