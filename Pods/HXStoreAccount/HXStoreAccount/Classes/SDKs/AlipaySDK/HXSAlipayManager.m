//
//  HXSAlipayManager.m
//  store
//
//  Created by chsasaw on 15/4/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSAlipayManager.h"

#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "NSString+Addition.h"
#import "HXMacrosUtils.h"
#import "ApplicationSettings.h"
#import "HXSOrderInfo.h"
#import "HXMacrosEnum.h"

static HXSAlipayManager * alipay_instance = nil;

@interface HXSAlipayManager()

@end

@implementation HXSAlipayManager

+ (HXSAlipayManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (alipay_instance == nil) alipay_instance = [[HXSAlipayManager alloc] init];
    });
    return alipay_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (url && [url.host isEqualToString:@"safepay"]) {
        
        NSString * urlString = [NSString decodeString:url.query];
        id json = [NSJSONSerialization JSONObjectWithData:[urlString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];;
        if(json && [json isKindOfClass:[NSDictionary class]]) {
            if(DIC_HAS_DIC(json, @"memo")) {
                NSDictionary * memoDic = [json objectForKey:@"memo"];
                if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                    NSString * message = [memoDic objectForKey:@"memo"];
                    NSString * status = [memoDic objectForKey:@"ResultStatus"];
                    NSDictionary * result = nil;
                    if(DIC_HAS_DIC(memoDic, @"result")) {
                        result = [memoDic objectForKey:@"result"];
                    }
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:result];
                    }
                }
            }
        }
        
        return YES;
    }
    
    return NO;
}

- (void)pay:(HXSOrderInfo *)orderInfo delegate:(id<HXSAlipayDelegate>)delegate
{
    
    
    self.delegate = delegate;
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017083108483095";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALLnPZwVody/CX2vJbs1joARLzCS6lsaGrl95hEI2N2vuFrcJvfGQmTcbpYfoq7aNKbdAvxjPZqlE8dgcZP3taoAKVY4Ad9K1u6scrUIt7TCu/iTUP7fshf86qAZKRd35f3uE5hCCPIBql2lwEq+NSzLvpeGmzRyXtBHroTm0GCBAgMBAAECgYEAhgqp55txpiJgaxHitEyhUyUM9VjuTInXgilpSlQVoKu69iDC9ZxPPKDIHqTfUCDfmDI5vX5hts9+bUC+eH39Vnx5DfX800O80ciKbOBSzlDBB9cMMaYUAm8k+kE+PbF2pV/gNMdIoxfV6MwmejKOlmQrLK1pyfGhkbOQrrozGj0CQQDa1nDVmKQmpMNY8KhgYXOYT4NJHlJpR7It6LZjYtfuHzi0Sfue4oipZZKe8+GDgrV4Q4vSF7ZcFndwrxu5IgSfAkEA0Ui6NgDZf9weAPYJs+r3mZGyAEEXNqE9yewQ732mbcMrMHJ0MCyDu7TVcWCT6YtgFd/m+7EJO+aYyHiGXUlm3wJATeVHBMDwrVC4uE/xn10Q6IZlFQHWE+ORaQYM5hOpCPnUFVjAWC4Kt0GQj0QAYe+E6OoiOwZ1wxG8MkAifiO9wQJASsUG8gA/tHR5q7I7KTJLH2x0Aa8/kd7talSSgF2Nti1CIt7hL8zXi5pBn233qjqHK4mAxm8rc2EhOI4GwxFUVQJBALH1yo7spap0WiM/34OOOjopbY7APpJun1MvZpoCSeS8k+F/E2pQdsHP5K1onZKEXS5U1iOgzvditpOnkXULUbc=";
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    order.notify_url = @"http://pay.59store.com/pay/alipay/notify";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = orderInfo.typeName;
    order.biz_content.subject = [NSString stringWithFormat:@"59store%@订单", orderInfo.typeName];
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
   order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格 做测试时写0.01
    
//    //价格
//        if (kHXSOrderInfoInstallmentYES == [orderInfo.installmentIntNum integerValue]) {
//            order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",orderInfo.downPaymentFloatNum.floatValue]; // 分期
//        } else {
//            order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",orderInfo.order_amount.floatValue]; // 不分期
//        }
//    
//        if (0 < [orderInfo.attach length]) {
//            
//            order.biz_content.subject = orderInfo.attach;
//        }
//    
    //将商品信息拼接成字符串
    NSString *orderInformation = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInformation);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInformation withRSA2:YES];
    } else {
        signedString = [signer signString:orderInformation withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"hxstore";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if(resultDic) {
                
                if([resultDic objectForKey:@"memo"] && [[resultDic objectForKey:@"memo"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * memoDic = [resultDic objectForKey:@"memo"];
                    if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                        NSString * message = [memoDic objectForKey:@"memo"];
                        NSString * status = [memoDic objectForKey:@"ResultStatus"];
                        NSDictionary * result = nil;
                        if([memoDic objectForKey:@"result"] && [[memoDic objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                            result = [memoDic objectForKey:@"result"];
                        }
                        
                        if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                            [self.delegate payCallBack:status message:message result:result];
                        }
                    }
                }else if(DIC_HAS_STRING(resultDic, @"memo") && [resultDic objectForKey:@"resultStatus"]) {
                    
                    NSString * message = [resultDic objectForKey:@"memo"];
                    NSString * status = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"resultStatus"]];
                    NSString * result = [resultDic objectForKey:@"result"];
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:@{@"result":result}];
                    }
                }
            }
            
            
        }];
    }
//    /*
//     *商户的唯一的parnter和seller。
//     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
//     */
//    NSString *partner = nil;
//    NSString *seller = nil;
//    NSString *privateKey = nil;
//    HXSEnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    if (HXSEnvironmentStage == environmentType
//        || HXSEnvironmentQA == environmentType
//        || HXSEnvironmentTemai == environmentType) {
//        partner = @"2088021264733879";
//        seller = @"ningff@59store.com";
//        privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMDFzGuCF/YB2ycy\nA6EzLHTW1qVn4d3APcjvGFU7FpnX0P83n3ybHxDjv12y3jp9m1aONjCw9LGuJ63d\n5hXt6C3eww7+iz3k9QWWjB2ssvq0a9pfh5824IUAf1zFNANznaLDZzyOMLPpZjMt\nuN1w06t7dR0JDl1wb3PnacTIXQB9AgMBAAECgYAMjdUeOz6sOrq29r7dxKNkiIk6\nBGXlNxvO9iMzicGTC0cFF+4/Aysmwm43/+oRDRUMsf49dYi5+YmD/St6yh+QoBCj\n+w7J6BvYHcWJdyjIl8CLfdzePzh/DEU3Rb47c/XScxhM6/MfSO8RvNOt2sopk4R0\nEqiEvagCFiPEGcYLgQJBAPggDqT8WLPTP0Lb9BFB/GML3Epmn09rjm1l2vM9WHE7\ncT0GlmCfEdPk58fSYlTm8Y39T35iQjs1Km4TzeeQR4kCQQDG5ASvw9xhfeR15fOV\nEYSkzPa9iOFtpn3YqX1S8/UDvyPLT50LvKApRxKKw4fqvTL9LmkQ/q0xGqHgoeLf\nO0BVAkAw1Q5MxiUm7vJKVEOKifQEAjeOpPfBh6d2PE+FA5O+ZTZ6DivWRDgb/bbo\nCq2zi+gKS8ozU185i9MX6unhIvIRAkAtRd4jPExADO4iQDPQLOqqsNVBk5Ts5sci\nuIIEje+p6Kp3Lyoqb8dtXfZEi/m2X1bp9tSHv9EgqlVK0s7XzZ75AkEAjZuRy3V0\ncKS42q6nJRohPhyd1L+YyMUFFntxqKNg2AGQ7re/+jJVx9swgN95lljB4a26CArQ\nlaqAkJpC0jXTdw==";
//    } else {
//        partner = @"2088901490646751";
//        seller = @"zkp@59food.com";
//        privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAPdS8wdz1Gf+7T7j8b4Tw62QqThmfl5GA4D3XsOfg8zWgyagvvTng1f2QwouwBmxV4Yd5oAYK4/B3ZP+KfX6GT7vBHVBAtIWZdfFXFvj/kofaG2BVD+4cNNFaPApEFt8R91pV6TVWrO4rnbE0lz10Q/L5j1VLAKNXK/Nr8TqU/MVAgMBAAECgYA5drlmwt/YJeADm7ygOEFfw1u98fpsdwH7Zf5Ln3VlE3Y3dGPJzTy0JFChPgl+LrkyPSJAIt2EMjwEVap0L17LzpavPY0cvjBR3vmf76rBEQ2HCPNBVH5dF18oEdDSVu9eq8cQ5XCU1k0jAMFM4bJoG7mLUG3PVzvLboVLNhDqZQJBAP8i/6f/5N6JfS35Ic+5PgYIxpYNx1oLm1NRWv/B4JwHQs8KZzy7AA/GwGfRmfgdVda3s7KV7//HP0mNGWLAW28CQQD4KS7qQlIWKwAi9FoEfPxu8B4+ipsBlISysGG3Y34f9XW21iXuz+omdZpBSpLS8ZT39i6ua4H73qmWoi23sOe7AkEAi/U4B4HBnC4R5FlJKfk1Q/wmbAQs+oFpeIAlii1huFXnWUocrdzrQLxHqev6KXh2MS5evjWwDUDQv9lONrTMswJBAOAMRpgncncjMYddd1wv/7SlQ5kRiKrfjQLLLh3lTLzL3xBIvYyj2HIKoU8rZe3fQLCyaij9VSiyOgiOuZnrtPsCQBooAQ6R8roe9L0vl0i7pBkm8QoQdNhd/dtmLphCWHeT2WWLkoA7Mdvzo8CSC943jq9sDJlL1Fjcfkks8a+tiHg=";
//    }
//    
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    self.delegate = delegate;
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = orderInfo.order_sn; //订单ID（由商家自行制定）
//    order.productName = [NSString stringWithFormat:@"59store%@订单", orderInfo.typeName]; //商品标题
//    // 商品价格
//    if (kHXSOrderInfoInstallmentYES == [orderInfo.installmentIntNum integerValue]) {
//        order.amount = [NSString stringWithFormat:@"%.2f",orderInfo.downPaymentFloatNum.floatValue]; // 分期
//    } else {
//        order.amount = [NSString stringWithFormat:@"%.2f",orderInfo.order_amount.floatValue]; // 不分期
//    }
//    
//    if (0 < [orderInfo.attach length]) {
//        order.productDescription = orderInfo.attach;
//    }
//    
//    if (environmentType == HXSEnvironmentStage) {
//        order.notifyURL =  @"http://pay.59store.net/pay/alipay/notify";
//    } else if(environmentType == HXSEnvironmentQA) {
//        order.notifyURL = @"http://61.130.1.150:28081/pay/alipay/notify";
//    } else if(environmentType == HXSEnvironmentTemai){
//        order.notifyURL = @"http://61.130.1.150:58091/pay/alipay/notify";
//    }
//    else {
//        order.notifyURL =  @"http://pay.59store.com/pay/alipay/notify";
//    }
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"http://www.59store.com";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"hxstore";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            if(resultDic) {
//                if(DIC_HAS_DIC(resultDic, @"memo")) {
//                    NSDictionary * memoDic = [resultDic objectForKey:@"memo"];
//                    if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
//                        NSString * message = [memoDic objectForKey:@"memo"];
//                        NSString * status = [memoDic objectForKey:@"ResultStatus"];
//                        NSDictionary * result = nil;
//                        if(DIC_HAS_DIC(memoDic, @"result")) {
//                            result = [memoDic objectForKey:@"result"];
//                        }
//                        
//                        if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
//                            [self.delegate payCallBack:status message:message result:result];
//                        }
//                    }
//                }else if(DIC_HAS_STRING(resultDic, @"memo") && [resultDic objectForKey:@"resultStatus"]) {
//                    NSString * message = [resultDic objectForKey:@"memo"];
//                    NSString * status = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"resultStatus"]];
//                    NSString * result = [resultDic objectForKey:@"result"];
//                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
//                        [self.delegate payCallBack:status message:message result:@{@"result":result}];
//                    }
//                }
//            }
//        }];
//    }
}
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
