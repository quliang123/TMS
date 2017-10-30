package cn.ql.entity;

import java.io.Serializable;

/**
 * Created by 123 on 2017/09/29.
 */

public class Tms_computerroom implements Serializable {

    private Integer id;
    private String name;

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
}
