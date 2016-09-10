/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

@import LRMobileSDK;

/**
 * @author Bruno Farache
 */
@interface LRPushNotificationsDeviceService_v62 : LRBaseService

- (NSDictionary *)addPushNotificationsDeviceWithToken:(NSString *)token platform:(NSString *)platform error:(NSError **)error;
- (NSDictionary *)deletePushNotificationsDeviceWithToken:(NSString *)token error:(NSError **)error;
- (void)sendPushNotificationWithToUserIds:(NSArray *)toUserIds payload:(NSString *)payload error:(NSError **)error;
- (void)sendPushNotificationWithPlatform:(NSString *)platform tokens:(NSArray *)tokens payload:(NSString *)payload error:(NSError **)error;

@end