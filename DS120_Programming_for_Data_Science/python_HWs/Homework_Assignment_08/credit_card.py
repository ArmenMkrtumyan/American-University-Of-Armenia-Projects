class CreditCard:
    def __init__(self, balance: float, credit_limit: float, interest_rate: float):
        try:
            self.__balance = float(balance)
            self.__credit_limit = float(credit_limit)
            self.interest_rate = float(interest_rate)
        except ValueError:
            print("Wrong initalization, inputs must be floats.")
    def charge(self, amount):
        if (self.__balance + amount <= self.__credit_limit):
            self.__balance += amount
            print("Charged " + str(amount) + ": Now the balance is " + str(self.__balance))
        else:
            print ("Amount cannot be added since credit card limit is: " + str(self.__credit_limit))
    def make_payment(self, amount):
        if (self.__balance - amount >= 0):
            self.__balance -= amount
            print("Payed " + str(amount) + ": Now the balance is " + str(self.__balance))
        else:
            print ("Not enough balance")
    def get_balance(self):
        return (self.__balance)
    def get_credit_limit(self):
        return (self.__credit_limit)
    def get_interest_rate(self):
        return (self.interest_rate)