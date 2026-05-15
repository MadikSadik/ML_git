from pydantic import BaseModel
from typing import Optional


class PredictionRequest(BaseModel):
    city: str
    horizon_months: Optional[int] = 1
    my_property_price_per_sqm: Optional[float] = None