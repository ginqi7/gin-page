# /// script
# dependencies = [
#   "bilibili-api-python>=v17.4.0",
#   "curl_cffi",
# ]
# ///
import asyncio
from sys import argv
from bilibili_api import user, sync, request_settings


async def get_user_videos(uid, limit_n=10):
    """
    获指定用户的最近 n 个视频
    :param uid: 用户 ID (数字)
    :param limit_n: 需获的视频数
    """
    # 实例化用户对象
    request_settings.set("impersonate", "chrome131")
    u = user.User(uid)

    video_list = []
    page_num = 1
    page_size = 30  # B站默认一页通常是 30 数

    # print(f"开始获用户 {uid} 的视频...")
    try:
        res = await u.get_videos(pn=page_num, ps=page_size)
        v_list = res.get("list", {}).get("vlist", [])

        if not v_list:
            print("没有更多视频了")
            return []

        for v in v_list:
            video_info = {
                "title": v["title"],
                "bvid": v["bvid"],
                "play": v["play"],
                "created": v["created"],
                "length": v["length"],
                "desc": v["description"],
                "url": f"https://www.bilibili.com/video/{v['bvid']}",
            }
            video_list.append(video_info)

    except Exception as e:
        print(f"生错误: {e}")

    return video_list


if __name__ == "__main__":
    TARGET_UID = argv[1]
    WANT_N = 5

    videos = sync(get_user_videos(TARGET_UID, WANT_N))

    print(videos)
