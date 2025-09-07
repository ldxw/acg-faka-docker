<?php
declare(strict_types=1);

namespace App\Pay\VmqfoxPay\Impl;

use App\Util\Plugin;
/**
 * Class Signature
 * @package App\Pay\Kvmpay\Impl
 */
class Signature implements \App\Pay\Signature
{

    /**
     * 生成签名
     * @param array $data
     * @param string $key
     * @return string
     */
    public static function generateSignature(array $data, string $key): string
    {
        $param = isset($data['param']) ? $data['param'] : '';
        $str="".$data['payId'].$param.$data['type'].$data['price'].$data['reallyPrice'].$key;
        return md5($str);
    }
    /**
     * @inheritDoc
     */
    public function verification(array $data, array $config): bool
    {   
        $sign = $data['sign'];
        $generateSignature = $this-> generateSignature($data, $config['key']);
        if ($sign != $generateSignature) {
            return false;
        }
        return true;
    }
}