from typing import Tuple
from .models import HsrData
def save_hsr_data(user_id, id_card_number: str|None = None, phone_number:str|None=None, email:str|None=None):
    """
    user_id: line_userid
    """
    try:
        hsr_data, created = HsrData.objects.get_or_create(line_user_id=user_id)
        if id_card_number:
            hsr_data.id_card_number = id_card_number
        if phone_number:
            hsr_data.phone_number = phone_number
        if email:
            hsr_data.email = email
        hsr_data.save()
    except Exception as e:
        import traceback
        traceback.print_exc()
        
def find_hsr_data(user_id: str) -> Tuple[HsrData | None, bool]:
    """
    user_id: line_user_id\
    returned value: ({account, password}, founded)
    """
    if len(HsrData.objects.filter(line_user_id=user_id)) == 0:
        return None, False
    hsr_data = HsrData.objects.get(line_user_id=user_id)
    return hsr_data, True