from lotto import *
def user_lotto(*nums):

    nums_str = ', '.join(map(str, nums))
    msg = f"{nums_str} 번호가 적용된 로또"
    data = list(nums)
    while len(data) < 7:
        number = random.randint(1, 45)
        data.append(number)
    return msg, data

msg, data = user_lotto(12,2)
print(msg)
print(data)
msg, data = user_lotto(1,2,3,4,5)
print(msg)
print(data)