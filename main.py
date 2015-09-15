import settings
from handle_texts import TwilioHandler

twilio_handler = TwilioHandler(settings.MINT_EMAIL, settings.MINT_PASSWORD)
twilio_handler.send_text()