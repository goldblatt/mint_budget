import settings
from mint_data import MintData

from twilio.rest import TwilioRestClient


class TwilioHandler:
    def __init__(self, mint_email, mint_password):
        self._client = TwilioRestClient(settings.TWILIO_ACCOUNT, settings.TWILIO_TOKEN)
        # TODO: I should def hash this password b/c this is unsafe
        self.mint_data = MintData(mint_email, mint_password)

    def send_text(self):
        body = "Total Spend For Month: %s" % self._get_total_spend_for_month()
        self._client.messages.create(
            body=body,
            to=settings.CELL_PHONE,
            from_=settings.TWILIO_NUMBER
        )

    def _get_total_spend_for_month(self):
        return self.mint_data.get_spending_up_till_day()
