import datetime

import mintapi  # TODO: look into this repo


class MintData:
    def __init__(self, email, password):
        self.email = email
        # TODO: I should def hash this password b/c this is unsafe
        self.password = password
        # TODO: do i even need this _cached_spending. yeah right?
        self._cached_spending = None
        self._connection = mintapi.Mint(self.email, self.password)

    def _get_connection(self):
        # TODO: this seems like a silly way to handle connections
        if not self._connection:
            self._connection = mintapi.Mint(self.email, self.password)
        return self._connection

    def get_spending_up_till_day(self):
        if self._cached_spending:
            return self._cached_spending
        else:
            return self._get_today_spending()

    def _get_today_spending(self):
        mint_conn = self._get_connection()
        # TODO: store this in DB and only get if data is older than a day
        transactions = mint_conn.get_transactions()
        first_day_of_month = '%s-%s-01' % (datetime.datetime.now().year, datetime.datetime.now().month)
        all_transactions_for_month = transactions[transactions['date'] > first_day_of_month]
        sum = all_transactions_for_month['amount'].sum()
        return sum
