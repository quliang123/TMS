package cn.ql.service.impl;

import cn.ql.dao.ISys_userInfoDAO;
import cn.ql.dao.ITms_dicDAO;
import cn.ql.entity.Sys_privilege;
import cn.ql.entity.Sys_userInfo;
import cn.ql.entity.Tms_dic;
import cn.ql.service.ISys_userInfoService;
import cn.ql.service.ITms_dicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by 123 on 2017/09/27.
 */
@Service("ISys_userInfoService")
public class ISys_userInfoServiceImpl implements ISys_userInfoService {

    @Resource(name = "ISys_userInfoDAO")
    private ISys_userInfoDAO sys_userInfoDAO;

    public ISys_userInfoDAO getSys_userInfoDAO() {
        return sys_userInfoDAO;
    }

    public void setSys_userInfoDAO(ISys_userInfoDAO sys_userInfoDAO) {
        this.sys_userInfoDAO = sys_userInfoDAO;
    }

    public int delPrivilegeByUserId(Integer roleid) {
        return sys_userInfoDAO.delPrivilegeByUserId(roleid);
    }

    public int savePrivilege(Integer roleid, Integer userid) {
        return sys_userInfoDAO.savePrivilege(roleid, userid);
    }

    public Boolean addUser(Sys_userInfo userInfo) {
        return sys_userInfoDAO.addUser(userInfo);
    }

    public List<Sys_userInfo> getUserListByRid(Integer rid) {
        return sys_userInfoDAO.getUserListByRid(rid);
    }

    public Integer getCount(Map<String, Object> map) {
        return sys_userInfoDAO.getCount(map);
    }

    public List<Sys_userInfo> getUserInfoList(Map<String, Object> map) {
        return sys_userInfoDAO.getUserInfoList(map);
    }

    public Sys_userInfo isLogin(String uname, String upassword) {
        return sys_userInfoDAO.isLogin(uname, upassword);
    }

    public List<Sys_privilege> getPrivilegeByUid(Integer uid) {
        return sys_userInfoDAO.getPrivilegeByUid(uid);
    }
}
