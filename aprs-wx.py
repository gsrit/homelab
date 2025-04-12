import aprslib
import time
import board
import busio
import adafruit_bmp280

# BMP280 setup
i2c = busio.I2C(board.SCL, board.SDA)
bmp280 = adafruit_bmp280.Adafruit_BMP280_I2C(i2c, address=0x76)
bmp280.sea_level_pressure = 1013.25

# APRS settings (you can use NOCALL-13 for test, but real callsign is needed for aprs.fi visibility)
CALLSIGN = "CALLSIGN-13"
PASSCODE = "11111"  # For unverified callsigns, this is acceptable for local testing
POSITION = "1136.80N/19957.00E"

# Create APRS connection
ais = aprslib.IS(CALLSIGN, passwd=PASSCODE)
ais.connect()

while True:
    temp_c = bmp280.temperature
    temp_f = int(temp_c * 9 / 5 + 32)

    # Create simple WX packet with temperature
    wx_packet = f"{CALLSIGN}>APRS,TCPIP*:={POSITION}_t{temp_f:03}"

    print("Sending WX packet:", wx_packet)
    ais.sendall(wx_packet)

    time.sleep(300)  # Send every 5 mins
