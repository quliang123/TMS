package cn.ql.dao;

import cn.ql.entity.Sys_privilege;
import cn.ql.entity.Sys_role;
import cn.ql.entity.Sys_userInfo;

import java.util.List;

/**
 * Created by 123 on 2017/10/16.
 */

public interface ISys_roleDAO {

    public List<Sys_privilege> getRoleTreeByRoleId(Integer roleid);

    public List<Sys_privilege> getAllList();

    public List<Sys_role> getListing();
}
