""" Example handler file. """
import logging
import runpod
import torch
from transformers import AutoTokenizer
from awq import AutoAWQForCausalLM

# If your handler runs inference on a model, load the model here.
# You will want models to be loaded into memory before starting serverless.


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
logging.basicConfig(level=logging.INFO)

logging.info("Loading model...")
model = AutoAWQForCausalLM.from_quantized(
    "/Mistral-7B-v0.1-qagen-v2.1-AWQ", device_map="auto"
)
logging.info("Model loaded.")
logging.info("Loading tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(
    "/Mistral-7B-v0.1-qagen-v2.1-AWQ", trust_remote_code=True, device_map="auto"
)
logging.info("Tokenizer loaded.")


def generate(prompt, token_limit=512):
    model.eval()
    with torch.no_grad():
        model_input = tokenizer(prompt, return_tensors="pt").input_ids.cuda()
        return tokenizer.decode(
            model.generate(**model_input, max_new_tokens=token_limit)[0],
            skip_special_tokens=True,
        )


def handler(job):
    """Handler function that will be used to process jobs."""
    prompt = job["input"]["text"]
    output = generate(prompt)
    return output


runpod.serverless.start({"handler": handler})
