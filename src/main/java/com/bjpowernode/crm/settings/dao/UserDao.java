package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    List<User> getUserList();

    User login(Map<String, String> map);
}
