from app import app

def main():
	app.debug= True
	app.run(host='0.0.0.0', port=5000)

if __name__ == '__main__':
	main()
