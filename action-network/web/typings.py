from typing import Union
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
    state: Union[str, None]
    phone: Union[str, None]


class Pressure(WidgetAction):
    """Represents widget pressure model"""
    form_data: FormData


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
    complementary: Union[str, None]


class CheckoutData(BaseModel):
    """CheckoutData"""
    email: str
    phone: Phone
    document_number: str
    name: str
    address: Address


class Donation(WidgetAction):
    """Represents widget donation model"""
    checkout_data: CheckoutData
    amount: int
    transaction_status: str
    payment_method: str


class Data(BaseModel):
    """Hasura Data Model"""
    new: Union[Donation, Form, Pressure]


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
