package cn.ql.entity;

import java.io.Serializable;

/**
 * Created by 123 on 2017/09/27.
 */

public class Tms_dic implements Serializable{
    private Integer id;
    private String name;
    private Integer type;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

}
