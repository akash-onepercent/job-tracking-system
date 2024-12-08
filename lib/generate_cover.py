import asyncio
import aiohttp
import json
import sys
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph
import os

# Function to send request to the model API and get the response
async def test_lm_studio(json_string, job_description):
    url = "http://localhost:1234/v1/chat/completions"
    headers = {"Content-Type": "application/json"}
    user_message = f"Generate a cover letter based on my resume and the job description. Here is my portfolio: {json_string}. Job Description: {job_description}"
    
    payload = {
        "messages": [{"role": "user", "content": user_message}],
        "temperature": 0.7,
        "max_tokens": 200
    }

    try:
        async with aiohttp.ClientSession() as session:
            async with session.post(url, json=payload, headers=headers) as response:
                print(f"Status: {response.status}")
                data = await response.text()
                # Extract the text content from the response
                result = json.loads(data)
                cover_letter = result.get("choices", [{}])[0].get("message", {}).get("content", "No content generated")
                return cover_letter
    except Exception as e:
        print(f"Error: {e}")
        return None

# Function to generate a PDF from the result
def generate_pdf(content):
    # Get the Downloads or Desktop directory path
    download_path = os.path.join(os.path.expanduser("~"), "Downloads", "cover_letter.pdf")
    
    if not os.path.exists(os.path.dirname(download_path)):
        os.makedirs(os.path.dirname(download_path))
    
    # Create a PDF with the content
    doc = SimpleDocTemplate(download_path, pagesize=letter)
    styles = getSampleStyleSheet()
    
    # Paragraph style to automatically wrap text and adjust font size if needed
    style = styles['Normal']
    style.fontName = "Helvetica"
    style.fontSize = 12
    style.leading = 14  # line height

    # Create the paragraph object, which will automatically handle line breaks and wrapping
    para = Paragraph(content.replace("\n", "<br />"), style)

    # Build the PDF with the paragraph content
    doc.build([para])

    print(f"PDF saved at {download_path}")

# Main logic to execute everything
async def main():
    json_string = sys.argv[1]  # First argument (jsonString)
    job_description = sys.argv[2]  # Second argument (job description)

    # Get the cover letter text from the model
    cover_letter = await test_lm_studio(json_string, job_description)

    if cover_letter:
        # Generate the PDF with the cover letter content
        generate_pdf(cover_letter)
    else:
        print("Failed to generate the cover letter.")

# Run the main function
if __name__ == "__main__":
    asyncio.run(main())
