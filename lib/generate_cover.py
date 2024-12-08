import asyncio
import aiohttp
import json
import sys
import os
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer

# Function to send request to the model API and get the response for cover letter
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
                result = json.loads(data)
                cover_letter = result.get("choices", [{}])[0].get("message", {}).get("content", "No content generated")
                return cover_letter
    except Exception as e:
        print(f"Error: {e}")
        return None

# Function to generate the resume PDF
def generate_resume_pdf(resume_data):
    # Set path to save resume PDF
    resume_path = os.path.join(os.path.expanduser("~"), "Downloads", "resume.pdf")
    
    if not os.path.exists(os.path.dirname(resume_path)):
        os.makedirs(os.path.dirname(resume_path))
    
    # Create a PDF document for the resume
    doc = SimpleDocTemplate(resume_path, pagesize=letter)
    styles = getSampleStyleSheet()
    
    # Paragraph style for the body text
    style = styles['Normal']
    style.fontName = "Helvetica"
    style.fontSize = 12
    style.leading = 14  # line height
    
    content = []
    
    # Resume header with name and contact info
    full_name = f"{resume_data['firstName']} {resume_data['middleName']} {resume_data['lastName']}".strip()
    content.append(Paragraph(f"<b>{full_name}</b>", style))
    content.append(Spacer(1, 12))
    content.append(Paragraph(f"Phone: {resume_data['phone']}", style))
    content.append(Spacer(1, 12))
    content.append(Paragraph(f"Email: {resume_data['address']}", style))
    content.append(Spacer(1, 12))
    content.append(Paragraph(f"Location: {resume_data['city']}, {resume_data['countryCode']}", style))
    content.append(Spacer(1, 20))
    
    # Summary
    content.append(Paragraph("<b>Summary:</b>", style))
    content.append(Spacer(1, 8))
    content.append(Paragraph(resume_data["summary"], style))
    content.append(Spacer(1, 12))
    
    # Education
    content.append(Paragraph("<b>Education:</b>", style))
    content.append(Spacer(1, 8))
    for education in resume_data["educationFields"]:
        degree = f"{education['degree']} - {education['institution']} ({education['educationLevel']})"
        content.append(Paragraph(degree, style))
        content.append(Spacer(1, 8))
        content.append(Paragraph(f"GPA: {education['gpa']}/{education['gpaMax']}", style))
        content.append(Spacer(1, 12))
    
    # Experience
    content.append(Paragraph("<b>Experience:</b>", style))
    content.append(Spacer(1, 8))
    for experience in resume_data["companyFields"]:
        experience_text = f"{experience['experienceCompany']} ({experience['experienceCountry']})"
        content.append(Paragraph(experience_text, style))
        content.append(Spacer(1, 8))
        content.append(Paragraph(f"Role: {experience['experienceCompany']}", style))
        content.append(Spacer(1, 8))
        content.append(Paragraph(f"Description: {experience['description']}", style))
        content.append(Spacer(1, 12))
    
    # Technical Skills
    content.append(Paragraph("<b>Technical Skills:</b>", style))
    content.append(Spacer(1, 8))
    for skill in resume_data["technicalSkills"]:
        content.append(Paragraph(f"- {skill}", style))
        content.append(Spacer(1, 8))
    
    # Build the resume PDF
    doc.build(content)
    print(f"Resume PDF saved at {resume_path}")

# Function to generate the cover letter PDF
def generate_cover_letter_pdf(cover_letter):
    cover_letter_path = os.path.join(os.path.expanduser("~"), "Downloads", "cover_letter.pdf")
    
    if not os.path.exists(os.path.dirname(cover_letter_path)):
        os.makedirs(os.path.dirname(cover_letter_path))
    
    # Create the PDF for the cover letter
    doc = SimpleDocTemplate(cover_letter_path, pagesize=letter)
    styles = getSampleStyleSheet()
    
    # Paragraph style for the body text
    style = styles['Normal']
    style.fontName = "Helvetica"
    style.fontSize = 12
    style.leading = 14  # line height
    
    content = []
    
    # Cover letter header
    content.append(Paragraph("<b>Cover Letter</b>", style))
    content.append(Spacer(1, 12))
    content.append(Paragraph(f"Dear Hiring Manager,", style))
    content.append(Spacer(1, 12))
    
    # Cover letter body
    content.append(Paragraph(cover_letter.replace("\n", "<br />"), style))
    content.append(Spacer(1, 12))
    
    # Close the letter
    content.append(Paragraph("Sincerely,", style))
    content.append(Spacer(1, 12))
    content.append(Paragraph("Your Name", style))
    
    # Build the cover letter PDF
    doc.build(content)
    print(f"Cover Letter PDF saved at {cover_letter_path}")

# Main logic to execute everything
async def main():
    json_string = sys.argv[1]  # First argument (jsonString)
    job_description = sys.argv[2]  # Second argument (job description)

    # Parse the input JSON string to extract resume data
    resume_data = json.loads(json_string)

    # Get the cover letter text from the model
    cover_letter = await test_lm_studio(json_string, job_description)

    if cover_letter:
        # Generate the PDF with the cover letter content
        generate_cover_letter_pdf(cover_letter)
    else:
        print("Failed to generate the cover letter.")
    
    # Generate the resume PDF
    generate_resume_pdf(resume_data)

# Run the main function
if __name__ == "__main__":
    asyncio.run(main())
