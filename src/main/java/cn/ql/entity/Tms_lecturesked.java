package cn.ql.entity;

import java.io.Serializable;

/**
 * Created by 123 on 2017/09/29.
 */

public class Tms_lecturesked implements Serializable{
    private Integer id;
    private String cname;
    private Integer tid;
    private Integer timestate;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public Integer getTid() {
        return tid;
    }

    public void setTid(Integer tid) {
        this.tid = tid;
    }

    public Integer getTimestate() {
        return timestate;
    }

    public void setTimestate(Integer timestate) {
        this.timestate = timestate;
    }
}
