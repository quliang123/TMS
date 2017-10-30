package cn.ql.dao;

import cn.ql.entity.Sys_privilege;
import cn.ql.entity.Sys_userInfo;

import java.util.List;
import java.util.Map;

/**
 * Created by 123 on 2017/10/16.
 */

public interface ISys_userInfoDAO {
    public int delPrivilegeByUserId(Integer roleid);

    public int savePrivilege(Integer userid, Integer privilegeid);

    public Boolean addUser(Sys_userInfo userInfo);

    public List<Sys_userInfo> getUserListByRid(Integer rid);

    public Integer getCount(Map<String, Object> map);

    public List<Sys_userInfo> getUserInfoList(Map<String, Object> map);

    public Sys_userInfo isLogin(String uname, String upassword);

    public List<Sys_privilege> getPrivilegeByUid(Integer uid);
}
