<?php
declare(strict_types=1);

namespace App\Service\Impl;


use App\Consts\Manage as ManageConst;
use App\Model\Manage;
use App\Model\ManageLog;
use App\Service\ManageSSO;
use App\Util\Client;
use App\Util\Date;
use App\Util\Str;
use Firebase\JWT\JWT;
use Kernel\Exception\JSONException;

/**
 * Class ManageSSOService
 * @package App\Service\Impl
 */
class ManageSSOService implements ManageSSO
{

    /**
     * @param string $username
     * @param string $password
     * @return array
     * @throws JSONException
     */
    public function login(string $username, string $password): array
    {
        $manage = Manage::query()->where("email", $username)->first();
        if (!$manage) {
            throw new JSONException("该邮箱不存在");
        }
        if (Str::generatePassword($password, $manage->salt) != $manage->password) {
            throw new JSONException("密码错误");
        }

        if ($manage->status != 1) {
            throw new JSONException("账号已被暂停使用");
        }

        if ($manage->type == 2 && Date::isNight()) {
            throw new JSONException("您是白班哦，请注意休息。");
        }

        if ($manage->type == 3 && !Date::isNight()) {
            throw new JSONException("您是夜班哦，请注意休息。");
        }

        $manage->last_login_time = $manage->login_time;
        $manage->last_login_ip = $manage->login_ip;
        $manage->login_time = Date::current();
        $manage->login_ip = Client::getAddress();
        $manage->save();

        ManageLog::log($manage, "登录了后台");


        $payload = array(
            "expire" => time() + (86400 * 30),
            "loginTime" => $manage->login_time
        );

        $jwt = base64_encode(JWT::encode(
            payload: $payload,
            key: $manage->password,
            alg: 'HS256',
            head: ["mid" => $manage->id]
        ));

        setcookie(ManageConst::SESSION, $jwt, time() + (86400 * 30), "/");

        return ["username" => $manage->email, "avatar" => $manage->avatar, "token" => $jwt];
    }
}