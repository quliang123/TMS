package cn.ql.entity;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by 123 on 2017/10/16.
 */
public class Sys_privilege implements Serializable {
    @Override
    public String toString() {
        return "Sys_privilege{" +
                "id=" + id +
                ", url='" + url + '\'' +
                ", name='" + name + '\'' +
                ", parent=" + parent +
                ", children=" + children +
                ", icon='" + icon + '\'' +
                ", checked=" + checked +
                '}';
    }

    private Integer id;
    private String url;
    private String name;
    private Integer parent;
    private List<Sys_privilege> children = new LinkedList<Sys_privilege>();
    private String icon;
    private boolean checked;

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public String getIcon() {
        return icon;
    }


    public void setIcon(String icon) {
        this.icon = icon;
    }

    public List<Sys_privilege> getChildren() {
        return children;
    }

    public void setChildren(List<Sys_privilege> children) {
        this.children = children;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getParent() {
        return parent;
    }

    public void setParent(Integer parent) {
        this.parent = parent;
    }
}
