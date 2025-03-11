from typing import Optional
from pydantic import BaseModel, Field


class WidgetAction(BaseModel):
    """Base widget action"""
    id: int
    created_at: str
    cached_community_id: int
    widget_id: int
    mobilization_id: int


class Form(WidgetAction):
    """Represents widget form model"""
    fields: str


class FormData(BaseModel):
    """Represents pressure form data"""
    email: str
    subject: str
    lastname: str
    body: str
    name: str
    state: Optional[str] = None
    phone: Optional[str] = None

class Pressure(WidgetAction):
    """Represents widget pressure model"""
    form_data: FormData

class PlipFormData(BaseModel):
    """Represents plip form data"""
    email: str
    state: str
    color: Optional[str] = None
    whatsapp: Optional[str] = None
    gender: Optional[str] = None
    name: str
    expected_signatures: int

class Plip(WidgetAction):
    """Represents widget plip model"""
    form_data: PlipFormData
    unique_identifier: str

class Phone(BaseModel):
    """Phone"""
    ddd: str
    number: str

class Address(BaseModel):
    """Address"""
    state: str
    zipcode: str
    street: str
    city: str
    street_number: str
    neighborhood: str
    complementary: Optional[str] = None


class CheckoutData(BaseModel):
    """CheckoutData"""
    email: str
    phone: Optional[Phone] = None
    document_number: str
    name: str
    address: Optional[Address] = None


class Donation(WidgetAction):
    """Represents widget donation model"""
    checkout_data: CheckoutData
    amount: int
    transaction_status: str
    payment_method: str
    subscription: bool


class Data(BaseModel):
    """Hasura Data Model"""
    new: Pressure | Plip | Donation | Form


class Event(BaseModel):
    """Hasura Event Model"""
    data: Data


class Table(BaseModel):
    """Hasura Table Model"""
    name: str
    schema_: str = Field('', alias="schema")


class Payload(BaseModel):
    """Hasura Event Payload"""
    event: Event
    table: Table
