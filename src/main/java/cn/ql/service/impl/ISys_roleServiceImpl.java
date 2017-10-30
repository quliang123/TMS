package cn.ql.service.impl;

import cn.ql.dao.ISys_roleDAO;
import cn.ql.dao.ISys_userInfoDAO;
import cn.ql.entity.Sys_privilege;
import cn.ql.entity.Sys_role;
import cn.ql.entity.Sys_userInfo;
import cn.ql.service.ISys_roleService;
import cn.ql.service.ISys_userInfoService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 123 on 2017/09/27.
 */
@Service("ISys_roleService")
public class ISys_roleServiceImpl implements ISys_roleService {

    @Resource(name = "ISys_roleDAO")
    private ISys_roleDAO sys_roleDAO;


    public List<Sys_privilege> getRoleTreeByRoleId(Integer roleid) {
        return sys_roleDAO.getRoleTreeByRoleId(roleid);
    }

    public List<Sys_privilege> getAllList() {
        return sys_roleDAO.getAllList();
    }

    public List<Sys_role> getListing() {
        return sys_roleDAO.getListing();
    }


    public ISys_roleDAO getSys_roleDAO() {
        return sys_roleDAO;
    }

    public void setSys_roleDAO(ISys_roleDAO sys_roleDAO) {
        this.sys_roleDAO = sys_roleDAO;
    }

}

